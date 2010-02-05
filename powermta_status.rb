#
# Copyright (c) 2010 Maarten Oelering
#
class PowermtaStatus < Scout::Plugin

  #needs 'gem1', 'gem2'

  #OPTIONS = <<-EOS
  #options:
  #  path_to_pmta:
  #    name: Path to pmta command
  #    notes: Specify the path to pmta command
  #    default: /usr/sbin
  #EOS
  
  def build_report
    status = get_status
    report(:inbound_connections => status['status.conn.smtpIn.cur'])
    report(:outbound_connections => status['status.conn.smtpOut.cur'])
    report(:inbound_traffic => status['status.traffic.lastMin.in.rcp'])
    report(:outbound_traffic => status['status.traffic.lastMin.out.rcp'])
    report(:smtp_queue_recipients => status['status.queue.smtp.rcp'])
  rescue
    error("Error building report: #{$!}")
  end
  
  private
  
    # get current powermta status parameter values
    def get_status
      # path = option(:path_to_pmta)
      output = `/usr/sbin/pmta --dom show status`
      status = {}
      output.each do |line|
        name, value = line.split('=')
        next if name.nil? or value.nil?
        status[name] = value.chomp[1...-1] # remove trailing LF and quotes
      end
      status
    end
end
