class StoredActivity

  def self.get_things(location)
    result_array = []
    StoredActivity.information.each do |activity|
      name = activity[:name]
      description = activity[:description]
      result_array << Thing.new(name: name, description: description, address: location, thing_type: "activity")
    end
    result_array
  end

  def self.information
    [{
      name: "Go Car Tours",
      description: "See the local side of Lisbon! Let the StoryTelling GoCar be your sightseeing tour guide."
      },
      {
      name: "Paintball",
      description: "Have a blast with your friends when chasing each other in fun teams"
      },
      {
      name: "Boating",
      description: "Rent a boat and spend the day on the water"
      },
      {
      name: "Gambling",
      description: "Hit the Casino and win big"
      },
      {
      name: "Bubble Soccer",
      description: "Bubble Ball Soccer is the newest trend sport! An exciting twist on the traditional game of soccer, you will be wrapped in a giant, soft inflatable Bubble Ball with shoulder harnesses and handles inside! Get ready to have a blast!"
      }]
  end
end
