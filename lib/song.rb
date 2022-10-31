class Song

  attr_accessor :name, :album, :id

  def initialize(name:, album:, id: nil)
    @id = id
    @name = name
    @album = album
  end

  def self.create_table
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS songs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        album TEXT
      )
      SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO songs (name, album)
      VALUES (?, ?)
    SQL

    # insert the song
    DB[:conn].execute(sql, self.name, self.album)

    # get the song ID from the database and save it to the Ruby instance
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]

    # return the Ruby instance
    self
  end

  def self.create(name:, album:)
    song = Song.new(name: name, album: album)
    song.save
  end

end




# id attribute
# A song gets an id only when it is saved in the database therefore default value of id is set to nil,so that we can create song instances that have no id value.
# Database handles this because it ensures that id of each record is unique.

# .create_table method (a class method)
# crafts SQL statement to create songs table with column names matching the attributes(name, album) of an instance of a song.
# class method creates table not an instance method.

# #save method (an instance method)
# Saves a given instance of our song into songs table of our database

# Bound parameters(?,?)
# Help us to pass the name and album (equivalent to VALUES(songs_name, songs_album)) by use of ? characters as placeholders
# Execute method then takes the songs_name and songs_album values and apply them as values of the ? character.

# .create method
# Here we use key arguments (name:, album:) to pass name and album in the method. we then use the name and album to intantiate a new song. Save method persists the song to the database

# NOTE
# we are not saving Ruby objects on the database! Instead we are saving individual attributes (equivalent to rows in a table) that describes an individual song. = a single row
# Intialize method (an instance method) creates a new instance of song class while save method (an instance method) takes attributes tat characterize a given song and saves them in a new row of the songs table