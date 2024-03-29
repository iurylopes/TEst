class JunOSwgo < Oxidized::Model

  comment  '# '

  def telnet
    @input.class.to_s.match(/Telnet/)
  end

  cmd :all do |cfg|
    cfg = cfg.lines.to_a[1..-2].join if screenscrape
    cfg.gsub!(/  scale-subscriber (\s+)(\d+)/,'  scale-subscriber                <count>')
    cfg.lines.map { |line| line.rstrip }.join("\n") + "\n"
  end

  cmd :secret do |cfg|
    cfg.gsub!(/encrypted-password (\S+).*/, '<secret removed>')
    cfg.gsub!(/community (\S+) {/, 'community <hidden> {')
    cfg
  end

  cmd 'show configuration | display set'
#  cmd 'show configuration | display omit'

#  cmd 'show version' do |cfg|
#    @model = $1 if cfg.match(/^Model: (\S+)/)
#    comment cfg
#  end

#  post do
#    out = ''
#    case @model
#    when 'mx960'
#      out << cmd('show chassis fabric reachability')  { |cfg| comment cfg }
#    when /^(ex22|ex33|ex4|ex8|qfx)/
#      out << cmd('show virtual-chassis') { |cfg| comment cfg }
#    end
#    out
#  end

  #cmd('show chassis hardware') { |cfg| comment cfg }
  #cmd('show system license') { |cfg| comment cfg }
  #cmd('show system license keys') { |cfg| comment cfg }

  cfg :telnet do
    username(/^login:/)
    password(/^Password:/)
  end

  cfg :ssh do
    exec true  # don't run shell, run each command in exec channel
  end

  cfg :telnet, :ssh do
    post_login 'set cli screen-length 0'
    post_login 'set cli screen-width 0'
    pre_logout 'exit'
  end

end
