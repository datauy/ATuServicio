class Datum < ApplicationRecord

  enum :dtype, [
    "value",
    "boolean",
    "price",
  ]
end
