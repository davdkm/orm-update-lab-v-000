require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name, :grade
  attr_reader :id
  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students(
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
      SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
      SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute('SELECT last_insert_rowid() FROM students')[0][0]
  end

  def self.create(name:, grade:)
    self.new(name, grade).save
  end

  def self.new_from_db(array)
    self.new(array[0], array[1], array[2])
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE students.name = ?
      SQL
    new_student = DB[:conn].execute(sql, name)
    self.new_from_db(new_student.flatten)
  end

  def update
    sql = <<-SQL
      UPDATE students SET name = ?, grade = ? WHERE id = ?
      SQL
    DB[:conn].execute(sql, self.name, self.grade , self.id)
  end
end
