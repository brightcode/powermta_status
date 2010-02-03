#
# Copyright (c) 2010 Maarten Oelering
#
class PowermtaStatus < Scout::Plugin
  
  def build_report
    # needs 'gem1', 'gem2'
    status = get_status
    report(:inbound_connections => status['status.conn.smtpIn.cur'])
    report(:inbound_traffic => status['status.traffic.lastMin.in.rcp'])
    report(:outbound_connections => status['status.conn.smtpOut.cur'])
    report(:outbound_traffic => status['status.traffic.lastMin.out.rcp'])
    report(:smtp_queue_recipients => status['status.queue.smtp.rcp'])
  rescue
    error("Error building report: #{$!}")
  end
  
  private
  
    # get current powermta status parameter values
    def get_status
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
