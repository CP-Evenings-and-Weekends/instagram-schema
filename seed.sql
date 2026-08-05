-- seed.sql

-- Users
INSERT INTO "user" (email, password, bio) VALUES
('alice@example.com', 'hashed_pw_1', 'Coffee and code.'),
('bob@example.com', 'hashed_pw_2', 'Dog dad, weekend hiker.'),
('carla@example.com', 'hashed_pw_3', 'Photographer based in Chicago.'),
('dave@example.com', 'hashed_pw_4', 'Just here for the memes.');

-- Posts
INSERT INTO post (user_id, caption, image_url, posted_at) VALUES
(1, 'Morning brew ☕', 'https://example.com/img1.jpg', '2026-08-01 08:15:00'),
(2, 'Trail day with Rex', 'https://example.com/img2.jpg', '2026-08-02 10:30:00'),
(3, 'Golden hour downtown', 'https://example.com/img3.jpg', '2026-08-03 19:45:00');

-- Comments (top-level, on posts — parent_comment_id NULL)
INSERT INTO comment (user_id, post_id, parent_comment_id) VALUES
(2, 1, NULL),   -- id 1: bob comments on alice's post
(3, 1, NULL),   -- id 2: carla comments on alice's post
(1, 2, NULL);   -- id 3: alice comments on bob's post

-- Replies (on other comments — post_id NULL)
INSERT INTO comment (user_id, post_id, parent_comment_id) VALUES
(1, NULL, 1),   -- id 4: alice replies to bob's comment (id 1)
(4, NULL, 1);   -- id 5: dave replies to bob's comment (id 1)

-- Likes (base rows first)
INSERT INTO "ig_likes" (user_id) VALUES
(2), (3), (4), (1);

-- Postlikes (link like rows 1-2 to a post)
INSERT INTO postlike (like_id, post_id) VALUES
(1, 1),  -- bob likes alice's post
(2, 1);  -- carla likes alice's post

-- Commentlikes (link like rows 3-4 to a comment)
INSERT INTO commentlike (like_id, comment_id) VALUES
(3, 1),  -- dave likes bob's comment
(4, 1);  -- alice likes bob's comment

-- Follows
INSERT INTO follow (follower_id, followed_id) VALUES
(2, 1),  -- bob follows alice
(3, 1),  -- carla follows alice
(1, 3);  -- alice follows carla
