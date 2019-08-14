require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :id, :name, :grade

  def initialize(name, grade, id=nil)
    @name, @grade, @id = name, grade, id
  end

  def self.create_table
    # pretty self explanatory
    # create a sql query and then we need to execute it
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        grade TEXT,
        name TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    # pretty self explanatory
    # create a sql query than we need to execute it
    sql = <<-SQL
      DROP TABLE IF EXISTS students
    SQL
    DB[:conn].execute(sql)
  end

  def save
    # need to save the instance of the student to the database
    # if the instance is already in the databse, we need to be able to update the record
    if self.id
      # if we have an id that means that we are in the database
      # all we need to do is update self
      self.update
    else
      # id self does not have an id,
      # we need to add self into the database
      # hence the 'else' statement
      sql = <<-SQL
        INSERT INTO students(name, grade)
        VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.grade)

      # now we need to set self.id to the id that is in the database
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students").flatten.first
      # we need first get [[id]], we need to flatten the array then get the value
      # also can do [0][0], but personally i like to flatten it then get the value.
    end
  end

  def self.create(name, grade)
    # create a new instance of self
    # now we need to call on student.save to add student into the database
    student = Student.new(name, grade)
    student.save
  end

  def self.new_from_db(row)
    # we can get all the necessary information to create a new student instance from
    # the argument that was given to us.
    id = row[0]
    name = row[1]
    grade = row[2]
    Student.new(name, grade, id)
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL
    DB[:conn].execute(sql, name).map { |row| self.new_from_db(row) }.first
    # DONT FORGET TO ADD NAME TO THE ARGUMENT FOR EXECUTE
    # then we need to map what we receive and then get '.first'
    # **** DB[:conn].execute(sql, name) ****
  end

  def update
    sql = <<-SQL
      UPDATE students
      SET name = ?, grade = ?
      WHERE id = ?
    SQL
    DB[:conn].execute(sql, self.name, self.grade, self.id)
    # like 'find_by_name, dont forget to the additional arguments to update in the database!!'
  end


end
