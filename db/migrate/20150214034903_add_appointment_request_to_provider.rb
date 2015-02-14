class AddAppointmentRequestToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :reserva_presencial, :string
    add_column :providers, :reserva_telefonica, :string
    add_column :providers, :reserva_web, :string
    add_column :providers, :reserva_consulta_medica, :string
    add_column :providers, :realiza_recordatorio_cita, :string
    add_column :providers, :realiza_caida_reserva_sin_confirmacion, :string
    add_column :providers, :comunicacion_usuario_suspension_modificacion, :string
  end
end
