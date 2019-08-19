require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql << -SQL 
    CREATE table if NOT EXISTS students(
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP table IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def save
    sql << -SQL
      INSERT INTO students (name, grade)
      VALUES(?,?)
    SQL

    DB[:connect].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("select last_insert roqid() from students")[0][0]
  end

  def self.create(name, grade)
    student = self.new(name, grade)
    student.save
  end

  def self.new_from_db(array)
    
  end

end
