# Instagram Schema

Design and implement a Postgres schema for a simplified Instagram — focusing on the **self-referential follow** relationship, which is the trickiest part of this schema.

> If you did Saturday's [Schema Design](https://github.com/CP-Evenings-and-Weekends/schema-design) challenge, you already drew an ERD for Instagram.  **Pull that diagram back up** as your starting point — today's job is to turn it into actual Postgres tables, seed it, and query it.  If you skipped Instagram on Saturday, do that ERD now before you start.

The included `init.sql`, `Dockerfile`, and `setup.sh` are wired up like [cars-database](https://github.com/CP-Evenings-and-Weekends/cars-database).

## Feature set to support

Aim for what Instagram had at launch:

- **Users** sign up (username, email, password, bio)
- **Posts** belong to one user, have a caption and an image URL, and a posted-at timestamp
- **Comments** belong to a post and a user (a user can comment on the same post multiple times)
- **Likes** — a user can like a post, but only **once** (a post + user pair is unique)
- **Follows** — a user can follow many users, and be followed by many.  Both sides point at `users` — this is the interesting one

## Requirements

### 1. Confirm or revise the ERD

Use Saturday's diagram (or build one now) in [dbdiagram.io](https://dbdiagram.io/) or [Quick Database Diagrams](https://www.quickdatabasediagrams.com/).  Commit a screenshot as `erd.png` or a Mermaid `erDiagram` block as `erd.md`.

You'll likely have: `users`, `posts`, `comments`, `likes`, `follows`.

### 2. Implement in `init.sql`

Translate the ERD into `CREATE TABLE` statements.  Conventions from Saturday: plural lowercase table names, `id` primary keys, `_id` foreign keys.

For **`follows`** specifically, you need two foreign keys back to `users`.  Name them clearly:

```sql
CREATE TABLE follows (
  follower_id  INT REFERENCES users(id),
  followed_id  INT REFERENCES users(id),
  followed_at  TIMESTAMP DEFAULT NOW(),
  PRIMARY KEY (follower_id, followed_id),
  CHECK (follower_id <> followed_id)
);
```

Notes on the above:
- The composite `(follower_id, followed_id)` primary key prevents duplicate follows
- The `CHECK` prevents a user from following themselves
- Two foreign keys to the same table is fine — disambiguate with descriptive names

For **`likes`**, do the same trick: composite primary key `(user_id, post_id)` so a user can't like the same post twice.

### 3. Seed it with data

2–3 rows per table is enough.  Make sure your follow data exercises both sides:
- At least one user who follows many other users
- At least one user who is followed by many other users
- A two-way follow (A follows B and B follows A) so your queries handle it

### 4. Build, run, and query

```bash
./setup.sh
```

Write at least 5 queries in `queries.sql`:

1. All posts by a given user, newest first
2. The number of likes on each of a given user's posts
3. Everyone a given user is **following** (returns a list of users)
4. Everyone who **follows** a given user (the inverse of #3)
5. A given user's feed: every post by every user they follow, newest first

## Things to think about
- For the follow relationship — why two foreign keys to `users` with different names (`follower_id`, `followed_id`) instead of one column?  How does that compare to how you modeled it Saturday?
- Why is `(user_id, post_id)` a better primary key for `likes` than adding a separate `id serial`?  When would you *want* the surrogate id instead?
- A user deletes their account.  What should happen to their posts, comments, likes, and follows?  Look up `ON DELETE CASCADE` vs `ON DELETE SET NULL`.
- Query 5 (the feed) joins `follows` to `posts` through `users`.  How would you avoid a user's own posts showing up in their feed?

## Stretch
- Add **hashtags** — a post can have many hashtags, and a hashtag can appear on many posts (many-to-many join table).  Write a query for "all posts tagged #sunset, newest first."
- Add **direct messages** — a user can send a message to another user.  Decide whether a message belongs to a single recipient or a conversation thread.
- Add a **counter view** that shows each user's follower count, following count, and post count in one row.
- Add an index on `follows.followed_id` and `EXPLAIN ANALYZE` query 4 before and after.

> Stuck? Have a code error? Use the ["4 Before Me"](https://docs.google.com/document/d/1nseOs5oabYBKNHfwJZNAR7GlU0zkZxNagsw63AD7XV0/edit) debugging checklist to help you solve it!
