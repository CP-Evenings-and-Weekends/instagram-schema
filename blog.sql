-- This is from an in-class example and brainstorming on how to structure instagram-like social media app

CHECK(first_name !~ '\s' AND last_name !~ '\s'),
CHECK (email ~* '^\w+@\w+[.]\w+$'),
CHECK (char_length(password)>=8)


CREATE TABLE Comment (
    id SERIAL PRIMARY KEY,
    text TEXT,
    user_id INTEGER REFERENCES BlogUser(id)
);

CREATE TABLE PostComment (
    comment_id INTEGER PRIMARY KEY REFERENCES Comment(id),
    post_id INTEGER NOT NULL REFERENCES Post(id)
);

CREATE TABLE ReplyComment (
    comment_id INTEGER PRIMARY KEY REFERENCES Comment(id),
    parent_comment_id INTEGER NOT NULL REFERENCES Comment(id)
);