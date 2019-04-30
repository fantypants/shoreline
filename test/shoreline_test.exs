defmodule ShorelineTest do
  use ExUnit.Case
  doctest Shoreline


  test "Retrieves Node ID" do
    assert is_integer(Shoreline.node_id()) == true
  end

  test "Timestamp returns 13 digit integer correctly" do
    time_stamp = Shoreline.timestamp()
    assert Enum.count(Integer.digits(time_stamp)) == 13
  end

  test "Timestamp returns 10 digit integer correctly" do
    time_stamp = Shoreline.time_to_seconds()
    assert Enum.count(Integer.digits(time_stamp)) == 10
  end

  test "LastID is formatted correctly" do
    last_id = 15566007190001000000
    assert Shoreline.format_last_id(last_id) == {[1, 5, 5, 6, 6, 0, 0, 7, 1, 9], [0, 0, 0, 1], [0, 0, 0, 0, 0, 0]}
  end

   test "gets a unique id" do
    time = Integer.digits(Shoreline.time_to_seconds)	
    node_id = Shoreline.check_id_length([Shoreline.node_id], 4) 
    old_host_id = 
    	Shoreline.get_increment(Integer.digits(:rand.uniform(99998)))	
    	|> Shoreline.check_id_length(6)
    
    last_id = Integer.undigits(time ++ node_id ++ old_host_id)
    new_host_id = 
    	Shoreline.get_increment(old_host_id) 
    	|> Shoreline.check_id_length(6)

    assert Shoreline.get_id(last_id) == Integer.undigits(time ++ node_id ++ new_host_id)
  end

  
end
