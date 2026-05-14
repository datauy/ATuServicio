class Datum < ApplicationRecord

  enum :dtype, [
    "value",
    "boolean",
    "array",
  ]
end
