class QueueProxy < Queue
  def initialize
    super
    @count = 0
  end

  def slow_pop(id)
    result = pop
    # puts @count
    while @count != 0
      # puts "result: #{result}"
      # (num_waiting).times do
      #   puts "num waiting: #{num_waiting}"
      #   puts "go again"
      Thread.new do
        push result
      end
      # puts size
      result = pop
      # puts "result: #{result}"
      #   puts "slow pop #{id}"
      # end
      # puts "#{@count}*"
    end
    # puts "after slow pop #{@count}"
    result
  end

  def fast_pop
    @count += 1
    result = pop
    # puts "after fast"
    @count -= 1
    result
  end
end

# TEST
blah = QueueProxy.new
test_numb = 20
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
      puts "normal #{count}: #{blah.slow_pop count}"
    end
  end
end
puts "end"
