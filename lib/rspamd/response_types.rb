# frozen_string_literal: true

require "json"

module Rspamd
  module ResponseTypes
    MESSAGE = Struct.new(
      :is_skipped,
      :score,
      :required_score,
      :action,
      :symbols,
      :messages,
      :message_id,
      :time_real,
      :milter
    ) do
      def symbol_score_sum
        symbols.map(&:score).sum
      end

      def symbol_metric_score_sum
        symbols.map(&:metric_score).sum
      end
    end

    SYMBOL = Struct.new(
      :name,
      :score,
      :metric_score,
      :description,
      :options
    )

    def self.convert(parsed_body)
      MESSAGE.new(
        parsed_body["is_skipped"],
        parsed_body["score"],
        parsed_body["required_score"],
        parsed_body["action"],
        parsed_body["symbols"].map do |_k, v|
          SYMBOL.new(
            v["name"],
            v["score"],
            v["metric_score"],
            v["description"],
            v["options"]
          )
        end,
        parsed_body["messages"],
        parsed_body["message-id"],
        parsed_body["time_real"],
        parsed_body["milter"]
      )
    end
  end
end
