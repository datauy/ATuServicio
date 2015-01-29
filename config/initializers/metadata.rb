def recursively_symbolize_keys(hash)
  hash.inject({}) do |result, (key, value)|
    transformed_key = (key.is_a? String) ? key.to_sym : key
    transformed_value = (value.is_a? Hash) ? recursively_symbolize_keys(value) : value

    result[transformed_key] = transformed_value
    result
  end
end

metadata = YAML.load_file(File.join(Rails.root, "config", "metadata.yml"))
METADATA = recursively_symbolize_keys(metadata)
