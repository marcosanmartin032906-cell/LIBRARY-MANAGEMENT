-- Campus Library: run this once in Supabase (SQL Editor -> New query -> Run).
-- Warning: the first line erases old library tables so you can re-run safely.
drop table if exists loans, students, books cascade;

create table books(
  id bigint generated always as identity primary key,
  isbn text,
  title text not null,
  author text not null,
  category text not null,
  copies int not null default 1 check (copies > 0)
);

create table students(
  id bigint generated always as identity primary key,
  student_no text unique not null,
  name text not null,
  course text not null,
  year int not null
);

create table loans(
  id bigint generated always as identity primary key,
  book_id bigint not null references books(id),
  student_id bigint not null references students(id),
  issued date not null default current_date,
  due date not null,
  returned date,
  fine int not null default 0
);

-- Open access for a class project. Add a login before using this for real.
alter table books enable row level security;
alter table students enable row level security;
alter table loans enable row level security;
create policy "open" on books for all using (true) with check (true);
create policy "open" on students for all using (true) with check (true);
create policy "open" on loans for all using (true) with check (true);

-- Sample data
insert into books(isbn,title,author,category,copies) values
('9780132350884','Clean Code','Robert C. Martin','Programming',2),
('9780078022159','Database System Concepts','Silberschatz','Databases',3),
('9780134685991','Effective Java','Joshua Bloch','Programming',2),
('9780321125217','Domain-Driven Design','Eric Evans','Software Engineering',1),
('9780136042594','Artificial Intelligence: A Modern Approach','Russell & Norvig','Computer Science',2),
('9781492052197','Computer Networking: A Top-Down Approach','Kurose & Ross','Networking',2),
('9780142437087','Noli Me Tangere','Jose Rizal','Filipiniana',3),
('9780073523323','Discrete Mathematics','Kenneth Rosen','Mathematics',2);

insert into students(student_no,name,course,year) values
('2026-0001','Maria Santos','BSIT',3),
('2026-0002','Juan Dela Cruz','BSCS',2),
('2026-0003','Ana Reyes','BSIT',1),
('2026-0004','Paolo Garcia','BSIS',4);

insert into loans(book_id,student_id,issued,due,returned,fine) values
(1,1,current_date-20,current_date-6,null,0),
(2,2,current_date-3,current_date+4,null,0),
(2,1,current_date-30,current_date-16,current_date-14,10),
(7,3,current_date-40,current_date-26,current_date-26,0),
(6,4,current_date-2,current_date+5,null,0);
