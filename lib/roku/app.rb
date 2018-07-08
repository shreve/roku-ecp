module Roku
  App = Struct.new(:name, :id, :type, :version) do
    def launch!
      Client.launch(id)
    end

    class << self
      def parse(hash)
        App.new(*hash.values_at('__content__', 'id', 'type', 'version'))
      end
    end
  end
end
