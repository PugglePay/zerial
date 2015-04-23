module Zerial
  module BaseSerializer
    def to_json (object)
      as_json(object).to_json
    end

    def from_json (json_string)
      from_loaded_json(
        JSON.load(json_string)
      )
    end
  end
end
