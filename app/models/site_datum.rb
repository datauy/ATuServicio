class SiteDatum < ApplicationRecord
  belongs_to :datum, optional: true
  belongs_to :site

  enum :level, [
    "Primer nivel de atención",
    "Segundo nivel de atención",
    "Tercer nivel de atención",
  ]

end
