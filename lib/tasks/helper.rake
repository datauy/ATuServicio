require 'csv'

namespace :helper do
  #
  # Clean zones
  #
  desc 'Cleaning zones'
  task :conciliate_zones, [] => [:environment] do |_, args|
    #Zone.where(ztype: 'Localidad').each do |z|
    #  loc = Zone.search(z.name, 'Localidad')
    #  if loc.length > 1
    #    puts "RESULTADO REPETIDO: #{loc.pluck(:name).inspect} "
    #  end
    #end
    #remove_wrong()
    #get_empty_zones.delete_all
    #get_duplicated_zones()
    ambiguos_localidad
  end
  #
  task :reload_parents, [] => [:environment] do |_, args|
    @period = 1
    reload_zone_parents
  end
  #
  def get_empty_zones
    Zone.where.not(id: 
      Zone.where.not(parent_zone: nil).pluck(:parent_zone_id).uniq +
      ProviderSpecialist.where.not(zone_id: nil).pluck(:zone_id).uniq +
      GeoEntity.where.not(zone_id: nil).pluck(:zone_id).uniq +
      ProviderIndicator.where.not(zone_id: nil).pluck(:zone_id).uniq +
      Site.where.not(zone_id: nil).pluck(:zone_id).uniq
    )
  end
  #
  def update_zone_relations(from, to)
      Zone.where(parent_zone_id: from).update_all(parent_zone_id: to)
      ProviderSpecialist.where(zone_id: from).update_all(zone_id: to)
      GeoEntity.where(zone_id: from).update_all(zone_id: to)
      ProviderIndicator.where(zone_id: from).update_all(zone_id: to)
      Site.where(zone_id: from).update_all(zone_id: to)
  end
  #
  def zone_used(id)
    {
      pz: Zone.where(parent_zone_id: id).count,
      ps: ProviderSpecialist.where(zone_id: id).count,
      ge: GeoEntity.where(zone_id: id).count,
      pi: ProviderIndicator.where(zone_id: id).count,
      s: Site.where(zone_id: id).count,
    }
  end
  #
  def remove_wrong
    casmu = Provider.search("CASMU").first
    casmu_zones = casmu.sites.map{|s| s.zone_id}
    Zone.search("CASMU", "Punto").each do |z|
      if !casmu_zones.include? z.id
        zzd = Zone.where(wkt: z.wkt)
        last = zzd.last
        zzd.each do |zd|
          if zd.id != last.id
            puts "DELETE #{zd.name}"
            update_zone_relations(zd.id, last.id)
            #zd.destroy
          end
          
        end
      end
    end
  end
  # Duplicados
  # 
  def ambiguos_localidad
    Zone.where(ztype: 'Localidad').each do |l|
      zs = Zone.search(l.name, 'Localidad')
      if zs.length > 1
        puts "AMBIGUOS Location #{l.name} getting childs"
        zs.each do |c|
          childs = Zone.where(parent_zone: c.id).pluck(:id,:name)
          puts "AMBIGUOS childs for #{c.name} -> #{childs.inspect}"
        end
      end
    end
  end
  #
  def reload_zone_parents
    points = []
    parents = {}
    import_file('sedes-asse.csv') do |row|
      if row['estado etapa'].nil? || row['estado etapa'] != 'pendiente'
        state = Zone.search(row['departamento'], "Departamento")
        if state.empty?
          puts "DEPTO #{row['departamento']} O PROVIDER #{row['prestador']} NO ENCONTRADO "
          next
        end
        parent_id = state.first.id
        if row['localidad'].present?
          #Get Location
          location = Zone.where(name: row['localidad'].gsub('_',' '), ztype: "Localidad", parent_zone_id: parent_id)
          if location.empty?
            puts "LOCATION EMPTY CREATE #{row['localidad']} - #{parent_id}"
            location = [Zone.create({
              name: row['localidad'].gsub('_',' '),
              ztype: "Localidad",
              parent_zone_id: parent_id
            })]
            next
          end
          if location.length > 1 
            puts "MULTIPLE LOCATIONS #{location.pluck(:name).inspect}"
            next
          end
          location = location.first
          wkt = row['geometry'].present? ? row['geometry'] : "POINT (#{row['lon']}, #{row['lat']})"
          point = Zone.find_by({
            ztype: "Punto",
            wkt: wkt
          })
          if point.present?
            if point.parent_zone_id != location.id && point.id != 3360
              parents[point.id] = point.parent_zone_id
              puts "PARENT DIFFERE #{wkt} for #{row['localidad']}: #{point.id} -> #{point.parent_zone_id} != #{location.id}"
              #ANALISIS
              puts zone_used(point.id)
              point.update(parent_zone_id: location.id)
            end
          else
            points.push "POINT NOT FOUND #{wkt} for #{row['prestador']} in site #{row['nombre']}"
            next
          end
        end
      end
    end
    puts "#{points.join("\n")}"
    #puts "#{parents.keys.join(", ")}"
  end
  #
  def get_duplicated_zones
    Zone.where(ztype: 'Punto').each do |rz|
      l = 0
      zused = zone_used(rz.id)
      zused.values.map{|v| l += v }
      if l == 0
        puts "PUNTO REPETIDO, NO SE USA: #{rz.id} "  
      end
      if l > 1
        puts "PUNTO REPETIDO, MULTIPLE #{rz.id}: #{zused.inspect} "
      end
    end
  end
end