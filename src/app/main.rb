@temperature = nil
@device_id = nil

@i = 0

@delay = 3

def get_device_id
  puts "fetching device id..."
  @device_id = `ls /sys/bus/w1/devices/`.split("\n").select{|f| f.include? '-'}.first
  puts "- Device ID is #{@device_id}"

end

def get_temperature
  device_path = "/sys/bus/w1/devices/#{@device_id}/w1_slave"
  puts "Device Path is #{device_path}"
  
  file = File.open(device_path, "rb")
  contents = file.read
  @temperature = contents.split("\n").last.split('t=').last.to_f / 1000
end

def tick args
  @i = @i + 1

  puts $gtk.inspect

  args.outputs.sprites << [ 0, 0, 1280, 720, 'images/temperature-background.png' ]

  if @i < @delay
    args.outputs.sprites << [ 0, 0, 1280, 720, 'images/splash.png' ]
  end

  if @device_id.nil?
    get_device_id
  else
  	
  	get_temperature

  	if @i >= @delay
    	args.outputs.labels << [ 1280/2, 450, "#{'%.2f' % @temperature.round(2)}º", 84, 1, 255, 255, 255, "fonts/upheavtt.ttf" ]
    	args.outputs.labels << [ 1280/2, 290, "CELSIUS", 24, 1, 255, 255, 255, "fonts/upheavtt.ttf" ]
    	args.outputs.labels << [ 1280/2, 80, Time.now, 14, 1, 255, 255, 255, "fonts/upheavtt.ttf" ]
	end
  end
end
