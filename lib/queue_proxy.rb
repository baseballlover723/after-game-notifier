class QueueProxy < Queue
  def initialize
    super
    @count = 0
  end

  def slow_pop
    result = pop
    if @count != 0
      #   puts "go again #{id}"
      Thread.new do
        push result
      end
      result = pop
      @count = 0
    end
    result
  end

  def fast_pop
    @count += 1
    pop
  end
end

# TEST
blah = QueueProxy.new
test_numb = 10
Thread.new do
  sleep 1
  (1..test_numb).each do |numb|
    blah << numb
    sleep 0.1
  end
end
arr = []
test_numb.times do
  arr << (rand > 0.5)
end
count = 0
arr.each do |do_fast|
  sleep 0.01
  Thread.new do
    count += 1
    if do_fast
      puts "fast pop #{count}: #{blah.fast_pop}"
    else
      puts "normal #{count}: #{blah.slow_pop}"
    end
  end
end
puts "end"
