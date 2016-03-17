class QueueProxy < Queue
  def initialize
    super
    @count = 0
  end

  def slow_pop(id)
    count = @count
    @last_slow = true
    result = pop
    # puts @count
    if @count != 0
      # puts "result: #{result}"
      # (num_waiting).times do
      #   puts "num waiting: #{num_waiting}"
      #   puts "go again #{id}"
      Thread.new do
        push result
      end
      # puts size
      result = pop
      @count = 0
      # puts "result: #{result}"
      #   puts "slow pop #{id}"
      # end
      # puts "#{@count}*"
    end
    # puts "after slow pop #{@count}"
    result
  end

  def fast_pop
    @count += 1 if @last_slow
    @last_slow = false
    result = pop
    # puts "after fast"
    @count -= 1
    result
  end
end

# TEST
blah = QueueProxy.new
test_numb = 100
Thread.new do
  sleep 2
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
      puts "normal #{count}: #{blah.slow_pop count}"
    end
  end
end
puts "end"
