create table students (
    id serial unique, /* This only exists because /show_entries had an id column for some reason.
                         Clearly, the student id should be the primary key. It's a unique number
                            associated with the student. That's like, the best pkey definition.*/
    first_name text not null,
    last_name text not null,
    student_id integer primary key,
    university text not null,
    course text not null,
    username text not null,
    `password` text not null /* postgres should probably catch the keyword and understand, 
                                    but better to be safe than sorry, right?*/
);