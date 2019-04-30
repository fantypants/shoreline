defmodule Shoreline do
  @moduledoc """
  GlobalId module contains an implementation of a guaranteed globally unique id system.     
  """
  #
  @doc """
  Please implement the following function.
  64 bit non negative integer output
  """
  @spec get_id(non_neg_integer) :: non_neg_integer
  def get_id(last_id) do
      {old_stamp, node_id, host_id} = format_last_id(last_id)
      existing_stack = [] #Here we would have a persistant key value storage witht he associated global id's
      new_host_id = get_increment(host_id)
      new_id = {time_to_seconds, node_id, check_id_length(new_host_id, 6)}
      new_guid = format_to_global(new_id)
      with {:ok, valid_guid} <- validate_guid(new_guid, existing_stack) do
          valid_guid
      else {:error, message} ->
          IO.puts message
      end
  end


 @doc """
 validates the new id based off a KV store
  
  """
  @spec validate_guid(non_neg_integer, list) :: tuple
  def validate_guid(new_guid, existing_stack) do
    case Enum.member?(existing_stack, new_guid) do
      false -> 
        {:ok, new_guid}
      true -> 
        get_id(Enum.at(existing_stack, -1))
        # Alternatively you can also use:
        # [last_id | tail] = Enum.reverse(existing_stack)
      _-> {:error, "Something went wrong"}
    end
  end

  @doc """
  increments the host_id, this way we can manipulate the way it increments
  """
  @spec get_increment(list) :: non_neg_integer
  def get_increment(host_id), do: [Integer.undigits(host_id) + 1]

  @doc """
  parent function for any id needed to be deconstructed, this exposes this layer to the rest and doesnt touch the private functions
  """
  @spec format_last_id(non_neg_integer) :: tuple
  def format_last_id(last_id), do: format_to_guid(Integer.digits(last_id))

 @doc """
  formats the last_id into the tuple required to process further
  """
  defp format_to_guid(list) do
    [a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t] = list
    {[a,b,c,d,e,f,g,h,i,j], [k,l,m,n], [o,p,q,r,s,t]}
  end

  @doc """
  Checks the current list size and then caluclates the required padding to keep it consistant
  """
  def check_id_length([id], desired_length) do
    case desired_length do
      4 -> 
        Integer.digits(id)
        |> correct_list(4) 
      6 -> 
       Integer.digits(id)
        |> correct_list(6)
      _->
        :error
    end
  end

  @doc """
  Checking the list length and adding padding if needed
  """
  defp correct_list(list, len), do: List.duplicate(0, len - Enum.count(list)) ++ list

  @doc """
  Formats the new id into the correct format
  """
  defp format_to_global({time, node_id, host_id}), do: Integer.undigits(Integer.digits(time) ++ node_id ++ host_id)


 
  #
  # You are given the following helper functions
  # Presume they are implemented - there is no need to implement them. 
  #

  @doc """
  Returns your node id as an integer.
  It will be greater than or equal to 0 and less than or equal to 1024.
  It is guaranteed to be globally unique.

  For testing purposes I have routed the node id to a random number from 0 ~> 1024.
  max unit 4 min unit 1

  1 - 4

  """

  @spec node_id() :: non_neg_integer
  def node_id, do: :rand.uniform(1024)

  @doc """
  Returns timestamp since the epoch in milliseconds.

  13 units

  for seconds:
  1556 600719 // 10


  """
  @spec timestamp() :: non_neg_integer
  def timestamp, do: :os.system_time(:millisecond)

  @doc """
  Here i am simply getting the value in seconds, due to the case basis, however, 
  within this step we could hash the time stamp or do anything else we need to it in order to alter the format correctly
  """
  @spec time_to_seconds() :: non_neg_integer
  def time_to_seconds, do: :os.system_time(:second)


end
