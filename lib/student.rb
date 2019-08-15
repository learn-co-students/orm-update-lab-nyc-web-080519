require_relative "../config/environment.rb"
require 'pry'
class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_reader :grade
  attr_accessor :id, :name

  def initialize (name, grade, id=nil)
    @id = id
    @name = name
    @grade = grade
  end  # ends initialize method

  def self.create_table
    sql = <<-SQL
      CREATE TABLE students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      );
    SQL
    DB[:conn].execute(sql)
  end  # ends self.create_table method

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students;
    SQL
    DB[:conn].execute(sql)
  end  # ends self.drop_table method

  def update 
    sql = <<-SQL
        UPDATE students SET name = ?, grade = ? WHERE id = ?;
      SQL
      DB[:conn].execute(sql, self.name, self.grade, self.id)
  end  # ends update method

  def save
    if self.id
      self.update
    else
    sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?, ?);
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students;")[0][0]
    end  # ends if loop
  end  # ends save method


  def self.create(name, grade)
    new_student = Student.new(name, grade)
    new_student.save
    new_student
  end  # ends create method

  def self.new_from_db(row)
    Student.new(row[1], row[2], row[0])
  end  # ends self.new_from_db

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?;
    SQL
    row = DB[:conn].execute(sql,name).first
    Student.new(row[1],row[2],row[0])
  end  # ends self.find_by_name method

end
