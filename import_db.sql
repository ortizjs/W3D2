PRAGMA foreign_keys = ON;


DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL 
);


DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);


DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  users_id INTEGER NOT NULL,
  questions_id INTEGER NOT NULL,

  FOREIGN KEY (users_id) REFERENCES users(id),
  FOREIGN KEY (questions_id) REFERENCES questions(id)
);


DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  questions_id INTEGER NOT NULL,
  replies_id INTEGER,
  users_id INTEGER NOT NULL,
  body TEXT NOT NULL,

  FOREIGN KEY (replies_id) REFERENCES replies(id),
  FOREIGN KEY (users_id) REFERENCES users(id),
  FOREIGN KEY (questions_id) REFERENCES questions(id)
);


DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  count INTEGER,
  users_id INTEGER NOT NULL,
  questions_id INTEGER NOT NULL,

  FOREIGN KEY (users_id) REFERENCES users(id),
  FOREIGN KEY (questions_id) REFERENCES questions(id)
);


INSERT INTO
  users (fname, lname)
VALUES
  ('Ricky', 'Bobby'),
  ('Ron', 'Burgandy');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('AppAcademy', 'This is a question?', 1),
  ('School', 'This is also a question?', 2);

INSERT INTO
  question_follows (users_id, questions_id)
VALUES
  (1, 2),
  (2,1);

INSERT INTO
  replies (questions_id, replies_id, users_id, body)
VALUES
  (1, 1, 2, 'This is Ron''s reply'),
  (2, 2, 1, 'This is Ricky''s reply');

INSERT INTO
  question_likes (count, users_id, questions_id)
VALUES
  (1, 1, 1),
  (1, 2, 2);