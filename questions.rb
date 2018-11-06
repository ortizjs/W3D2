require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton
  
  def initialize
    super('questions.db')
    self.type_translation = true 
  end
  
end

class User 
end 

class Question
end 

class Reply  
end 

class QuestionFollow
end 

class QuestionLike
end 