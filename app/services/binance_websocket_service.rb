# frozen_string_literal: true

# require 'websocket-client-simple'
class BinanceWebsocketService
  attr_reader :symbol

  def initialize(symbol = 'BTCUSDT')
    @symbol = symbol
  end

  def connect
    url = "wss://stream.binance.com:9443/ws/#{symbol.downcase}usdt@trade"
    ws = WebSocket::Client::Simple.connect(url)

    ws.on :message do |msg|
      data = JSON.parse(msg.data)
      data['p']

      # check_price_alerts(price)
    end

    ws.on :error do |e|
      Rails.logger.error("WebSocket error: #{e}")
    end

    ws.on :close do |code, reason|
      Rails.logger.info("WebSocket closed with code #{code} and reason #{reason}")
    end

    loop do
      sleep 1
    end
  end
end
