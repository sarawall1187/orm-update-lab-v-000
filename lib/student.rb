require_relative "../config/environment.rb"
require 'pry'
class Student
 attr_accessor :name, :grade, :id


 def initialize(name, grade, id = nil)
   @id = id
   @name = name
   @grade = grade
 end

 def self.create_table
   sql = <<-SQL
   CREATE TABLE IF NOT EXISTS students (
     id INTEGER PRIMARY KEY,
     name TEXT,
     grade INTEGER
    )
    SQL
    DB[:conn].execute(sql)
 end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
 end

  def save
    if self.id
      self.update
    else
      sql = "INSERT INTO students (name, grade) VALUES (?, ?)"
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def self.create(name, grade)
   new_student = Student.new(name, grade)
   new_student.save
   new_student
  end

  def self.new_from_db(row)
    new_student = Student.new(row[0], row[1], row[2])
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end
end
