# DB Challenge 1
---

So, I was bored and it showed up, and the only other person who'd done it had mentioned they wanted to use a salt. I already knew about Argon2, so naturally, using that to hash would both do the salt thing and be stronger.

The defaults that I checked out for the argon2-cffi package looked good (Argon2id, 16 bits salt, etc.) so we were good to go. The last thing that I included is environment variables, because I'm running this on containers that other people have access to, so.. yeah. This lets me keep it nice and secure and still give a good usage.

## Usage
---

There are three things to get this running, after you pull the repo.
First, the Postgres DB. I assume most everyone looking at this knows how to make one. The important part is the table, which I have provided a script for in `table.sql`. You can just run it, or copy it, or what have you.

> [!NOTE]
> If the user you are running this from doesn't own the database the table is in, you might get some weird errors along the lines of
> `permission denied for sequence students_id_seq`. You can have the user own the database, but StackOverflow tells me that you can also
> run
> ```sql
> grant usage, select on all sequences in schema public to <username>;
> ```

If you're using Nix, the `postgres.nix` file is pulled almost directly from my own configs running the container.
All you would need to do is change the password and run the script on the ch1 user.

The second thing to do is to setup the dependencies. I have included a pyproject.toml that conforms to the uv spec for those. It's roughly similar to a Poetry pyproject.toml, but the toml headers are a little different and the syntax is too.

Again, if you are using Nix, there is a flake for the whole setup. Go ahead and just do a `nix develop`.

Ok, last thing. You need to set some environment variables.

| Variable | Explanation |
| --- | ---- |
| DB_NAME | I mean it's the name of the database |
| DB_USER | also self-explanatory |
| DB_PASSWD | I spelt password wrong |
| DB_HOST | I think if you use localhost it will try to connect over the Unix socket. I didn't try that |
| DB_PORT | Postgres defaults to 5432, but do specify it |
| USE_HASH | if this even exists, it will hash passwords |

I have changed the software to accept a .env file, so if that's youre jam, you're good to go.

After that, just run `python app.py` and try it out.
The password file is just a `text` type, so if you swap between USE_HASH and not USE_HASH, you can see all of them in the same table.
