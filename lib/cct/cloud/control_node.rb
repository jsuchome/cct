module Cct
  class ControlNode
    LOG_TAG = "CONTROL_NODE"
    CONTROL_NODE_ROUTE = "/crowbar/nova/1.0/default"
    ENV_FILE = "/root/.openrc"

    extend Forwardable

    def_delegators :@control_node, :exec!, :connected?, :connect!, :test_ssh!,
                                   :admin?, :name, :ip, :user, :password, :port,
                                   :environment, :attributes

    def_delegators :@crowbar_proxy, :status, :state, :alias, :fqdn, :domain,
                                    :data, :loaded?

    attr_reader :log, :nodes, :control_node

    attr_accessor :crowbar_proxy

    alias_method :crowbar, :crowbar_proxy

    def initialize nodes
      @nodes = nodes
      @log = BaseLogger.new(LOG_TAG)
    end

    def unhumanize_results cmd
      lines = self.exec!(cmd).output.delete(' ').split("\n")
      lines.delete_if { |line| line.start_with?("+") }
      lines.map! { |line| line.split("|") }
      heading = lines.shift
      return heading, lines
    end

    def get_result_column cmd, column
      heading, lines = unhumanize_results(cmd)
      c = heading.index(column)
      result = []
      lines.each { |line| result.push line[c] }
      result
    end

    def get_result_item cmd, column, match
      heading, lines = unhumanize_results(cmd)
      key, value = match.split("=")
      k = heading.index(key)
      c = heading.index(column)
      kk = []
      cc = []
      lines.each { |line| kk.push line[k] }
      lines.each { |line| cc.push line[c] }
      if kk.index(value)
        cc[kk.index(value)]
      else
        nil
      end
    end

    def exec! command, *params
      self.load! unless control_node
      params << {environment: {source: [ENV_FILE]}}
      control_node.exec!(command, *params)
    end

    def inspect
      if control_node
        control_node.inspect
      else
        "<#{self.class}##{object_id} not loaded yet>"
      end
    end

    def controller?
      true
    end

    def config
      config = Cct.config.fetch("control_node", {})
      config = Cct.config.fetch("nodes", {}) if config.empty?
      config
    end

    def load!
      return @control_node if @control_node

      nodes.load!
      response = nodes.crowbar.get(CONTROL_NODE_ROUTE)
      if !response.success?
        fail CrowbarApiError,
          "Failed at #{response.env[:url]} while requesting controller node details"
      end

      # FIXME: In case there are several controller nodes, take the first one
      #        This strategy is not perfect but it's enough sofar
      #        as it's the typical setup of deployment
      controller_fqdn =
        response.body["deployment"]["nova"]["elements"]["nova-multi-controller"].first
      return unless controller_fqdn

      control_node_name = controller_fqdn.split(".").first
      @control_node = nodes.find do |node|
        node.name == control_node_name || node.name == controller_fqdn
      end
    end
  end
end
