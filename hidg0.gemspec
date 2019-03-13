Gem::Specification.new do |s|
  s.name = 'hidg0'
  s.version = '0.1.0'
  s.summary = 'Used with a Raspberry PI Zero plugged into a computer to act as USB Keyboard (HID).'
  s.authors = ['James Robertson']
  s.files = Dir['lib/hidg0.rb']
  s.signing_key = '../privatekeys/hidg0.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/hidg0'
end