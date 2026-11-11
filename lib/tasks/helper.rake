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
    get_duplicated_zones()
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