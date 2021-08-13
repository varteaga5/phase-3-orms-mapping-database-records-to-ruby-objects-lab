class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new 
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * 
      FROM students
      SQL

      all_rows = DB[:conn].execute(sql)
      all_rows.map do |student|
        self.new_from_db(student)
      end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL 
    SELECT *
    FROM students
    WHERE name = ?
    LIMIT 1
    SQL

    found_by_name = DB[:conn].execute(sql, name)
    found_by_name.map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.all_students_in_grade_X(count)
 
    sql = <<-SQL 
    SELECT *
    FROM students
    WHERE grade = ?
    ORDER BY id
    SQL
    student_array = DB[:conn].execute(sql, count)
    student_array.map do |row|
      self.new_from_db(row)
    end
  end


  def self.first_student_in_grade_10
    sql = <<-SQL 
    SELECT * 
    FROM students
    WHERE grade = 10
    ORDER BY id
    LIMIT 1
    SQL

    grade_10 = DB[:conn].execute(sql)
    grade_10.map do |element|
      self.new_from_db(element)
    end.first
  end


  def self.first_X_students_in_grade_10(count)
 
    sql = <<-SQL 
    SELECT *
    FROM students
    WHERE grade = 10
    ORDER BY id
    LIMIT ?
    SQL
    student_array = DB[:conn].execute(sql, count)
    student_array.map do |row|
      self.new_from_db(row)
    end
  end


  def self.all_students_in_grade_9 
    sql = <<-SQL 
    SELECT * 
    FROM students
    WHERE grade = 9
    SQL

    DB[:conn].execute(sql)

  end  
  
  def self.students_below_12th_grade
  sql = <<-SQL 
  SELECT * 
  FROM students
  WHERE grade < 12
  SQL

  below_12 = DB[:conn].execute(sql)
  below_12.map do |element|
    self.new_from_db(element)
  end

end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
