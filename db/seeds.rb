# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

Section.create!(title: 'Información General', name: 'general', description: '', year: 2026, period: 1, is_home_card: true, weight: 0, is_active: true)
Section.create!(title: 'Órdenes y tickets', name: 'prices', description: '', year: 2026, period: 1, is_home_card: true, weight: 1, is_active: true)
Section.create!(title: 'Metas asistenciales', name: 'goals', description: '', year: 2023, period: 2, is_home_card: false, weight: 2, is_active: true)
Section.create!(title: 'Personal básico orientado a la asistencia', name: 'rrhh', description: ' Los indicadores se construyen considerando cargos de 175 horas mensuales para medicina y de 144 horas mensuales para enfermería.', year: 2024, period: 1, is_home_card: true, weight: 4, is_active: true)
Section.create!(title: 'Méd. generales y especialistas c/alta dedicación', name: 'rrhh_cad', description: 'Los indicadores reflejan la cantidad de cargos de 175 horas mensuales cada 10.000 usuarios de referencia. ', year: 2024, period: 1, is_home_card: false, weight: 6, is_active: true)
Section.create!(title: 'Especialistas y principales profesiones', name: 'specialists', description: 'Los indicadores reflejan la cantidad de cargos de 175 horas mensuales cada 10.000 usuarios de referencia. ', year: 2024, period: 1, is_home_card: false, weight: 7, is_active: true)