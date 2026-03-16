require 'csv'

row1_string = false
CSV.foreach('solicitud_consultas.csv') do |r|
  if (r[1] != "SI" && r[1] != "NO")
    row1_string = true
  end
end

row2_string = false
CSV.foreach('solicitud_consultas.csv') do |r|
  if (r[2] != "SI" && r[2] != "NO")
    row2_string = true
  end
end

row3_string = false
CSV.foreach('solicitud_consultas.csv') do |r|
  if (r[3] != "SI" && r[3] != "NO")
    row3_string = true
  end
end

row4_string = false
CSV.foreach('solicitud_consultas.csv') do |r|
  if (r[4] != "SI" && r[4] != "NO")
    row4_string = true
  end
end

row5_string = false
CSV.foreach('solicitud_consultas.csv') do |r|
  if (r[5] != "SI" && r[5] != "NO")
    row5_string = true
  end
end

row6_string = false
CSV.foreach('solicitud_consultas.csv') do |r|
  if (r[6] != "SI" && r[6] != "NO")
    row6_string = true
  end
end

row7_string = false
CSV.foreach('solicitud_consultas.csv') do |r|
  if (r[7] != "SI" && r[7] != "NO")
    row7_string = true
  end
end

puts "row 1: #{row1_string}\nrow 2: #{row2_string}\nrow 3: #{row3_string}\nrow 4: #{row4_string}\nrow 5: #{row5_string}\nrow 6: #{row6_string}\nrow 7: #{row7_string}"

