# frozen_string_literal: true

module Rspamd
  class Reply
    class Symbol
      attr_reader :name, :score, :metric_score, :description, :options

      def initialize(name, score, metric_score, description, options)
        @name = name
        @score = score
        @metric_score = metric_score
        @description = description
        @options = options
      end
    end

    attr_reader :is_skipped, :score, :required_score, :action, :symbols, :messages, :message_id, :time_real, :milter

    def initialize(response)
      @is_skipped = response["is_skipped"]
      @score = response["score"]
      @required_score = response["required_score"]
      @action = response["action"]
      @symbols = response["symbols"].map do |_k, v|
        Reply::Symbol.new(
          v["name"],
          v["score"],
          v["metric_score"],
          v["description"],
          v["options"]
        )
      end
      @messages = response["messages"]
      @message_id = response["message-id"]
      @time_real = response["time_real"]
      @milter = response["milter"]
    end

    def total_score
      symbols.map(&:score).sum
    end

    def total_metric_score
      symbols.map(&:metric_score).sum
    end
  end
end
