create database fit_plan_hub;
use fit_plan_hub;

-- User Table
create table users
(
id int auto_increment primary key,
u_name varchar(100) not null,
mail_add varchar(150) not null unique,
pass_hash varchar(255) not null,
u_role enum('user','trainer') not null,
u_created_at timestamp default current_timestamp
);

-- fitness plans
create table fitness_plans
(
id int auto_increment primary key,
trainer_id int not null,
title varchar(100) not null,
p_description text not null,
price decimal(8,2) not null,
duration_days int not null,
created_at timestamp default current_timestamp
);

-- subscription table
create table subscriptions
(
id int auto_increment primary key,
user_id int not null,
plan_id int not null,
subscribed_at timestamp default current_timestamp,

unique(user_id,plan_id),

foreign key (user_id) references users(id) on delete cascade,
foreign key (plan_id) references fitness_plans(id) on delete cascade
);

-- trainer follower table
create table trainer_followers
(
id int auto_increment primary key,
user_id int not null,
trainer_id int not null,

unique(user_id,trainer_id),

foreign key (user_id) references users(id) on delete cascade,
foreign key (trainer_id) references users(id) on delete cascade
);

-- indexing for better performance
create index idx_plans_trainer on fitness_plans(trainer_id);
create index idx_subscriptions_user on subscriptions(user_id);
create index idx_followers_user on trainer_followers(user_id);