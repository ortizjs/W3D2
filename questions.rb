require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton
  
  def initialize
    super('questions1.db')
    self.type_translation = true 
    self.results_as_hash = true
  end
  
end




class User 
  attr_accessor :id, :fname, :lname
  def self.find_by_id(id)
    user = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM 
        users 
      WHERE 
        id = ?
    SQL

    return nil unless user.length > 0

    User.new(user.first)
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end
  
  def self.find_by_name(fname, lname)
    user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM 
        users 
      WHERE 
        fname = ? AND lname = ?
    SQL

    return nil unless user.length > 0

    User.new(user.first)
  end
  
  def authored_questions(id)
    question = Question.find_by_author_id(id)
    
  end
  
  def authored_replies(id)
    reply = Reply.find_by_user_id(id)
    
  end
  
  def followers 
    QuestionFollow.followed_questions_for_user_id(self.id)
  end

end 













class Question
  attr_accessor :id, :title, :body, :author_id
  
  def self.find_by_id(id)
    question = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
          *
        FROM 
          questions 
        WHERE 
          id = ?
    SQL
    
    return nil unless question.length > 0
    
    Question.new(question.first)  
  end
  
  def self.find_by_author_id(author_id)
    user = User.find_by_id(author_id)
    raise "#{author_id} not found in DB" unless user
    
    questions = QuestionsDatabase.instance.execute(<<-SQL, user.id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL

    questions.map { |u| Question.new(u) }
  end
  
  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end
  
  def author 
    User.find_by_id(self.author_id)
  end
  
  def replies
    Reply.find_by_question_id(self.id)
  end
  
  def followers
    QuestionFollow.followed_questions_for_user_id(self.id)
  end
end 




class Reply  
  attr_accessor :id, :users_id, :questions_id, :body, :replies_id
  def self.find_by_id(id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
          *
        FROM 
          replies 
        WHERE 
          id = ?
    SQL
    
    return nil unless reply.length > 0
  
    Reply.new(reply.first)  
  end
  
  def initialize(options)
    @id = options['id']
    @users_id = options['users_id']
    @questions_id = options['questions_id']
    @body = options['body']
    @replies_id = options ['replies_id']
  end
  
  
  def self.find_by_user_id(user_id)
    user = User.find_by_id(user_id)
    raise "#{user_id} not found in DB" unless user
    
    replies = QuestionsDatabase.instance.execute(<<-SQL, user.id)
      SELECT
        *
      FROM
        replies
      WHERE
        users_id = ?
    SQL

    result = []
    replies.map { |u| result << Reply.new(u) }
    result
  end
  
  def self.find_by_question_id(question_id)
    question = Question.find_by_id(question_id)
    raise "#{question_id} not found in DB" unless question
    
    replies = QuestionsDatabase.instance.execute(<<-SQL, question.id)
      SELECT
        *
      FROM
        replies
      WHERE
        questions_id = ?
    SQL

    replies.map { |q| Reply.new(q) }
  end
  
  def author 
    User.find_by_id(self.users_id)
  end
  
  def question
    Question.find_by_id(self.questions_id)
  end
  
  def parent_reply
    Reply.find_by_id(self.replies_id)
  end
  
  def child_replies
    replies = QuestionsDatabase.instance.execute(<<-SQL, self.id)
      SELECT
        *
      FROM 
        replies 
      WHERE
        replies_id = ?
    SQL
    result = []
    replies.map { |u| result << Reply.new(u) }
    result 
  end
  
end 






class QuestionFollow
  attr_accessor :id, :questions_id, :replies_id, :users_id, :body
  def self.find_by_id(id)
    question_follow = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
          *
        FROM 
          question_follows 
        WHERE 
          id = ?
    SQL
    
    return nil unless question_follow.length > 0

    QuestionFollow.new(question_follow.first)  
  end
  
  def initialize(options)
    @id = options['id']
    @questions_id = options['questions_id']
    @replies_id = options['replies_id']
    @users_id = options['users_id']
    @body = options['body'] 
  end
  
  def self.followers_for_question(question_id)
    
    question_follow = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.id, users.fname, users.lname
      FROM 
        question_follows 
      INNER JOIN users 
        ON question_follows.users_id = users.id 
      WHERE 
        questions_id = ?
    SQL
    
    result = []
    question_follow.map { |u| result << User.new(u) }
    result 
  end
  
  def self.followed_questions_for_user_id(user_id)
    question_follow = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.id, questions.title, questions.body, questions.author_id
      FROM 
        question_follows 
      INNER JOIN questions 
        ON question_follows.questions_id = questions.id 
      WHERE 
        users_id = ?
    SQL
    
    result = []
    question_follow.map { |u| result << Question.new(u) }
    result 
  end
  
end 





















class QuestionLike
  attr_accessor :id, :count, :users_id, :questions_id
  def self.find_by_id(id)
    question_like = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
          *
        FROM 
          question_likes 
        WHERE 
          id = ?
    SQL
    
    return nil unless question_like.length > 0

    QuestionLike.new(question_like.first)  
  end
  
  def initialize(options)
    @id = options['id']
    @count = options['count']
    @users_id = options['users_id']
    @questions_id = options['questions_id']
  end
  
end 
