# Monster Shop Final
## BE Mod 2 Week 6 Solo Project
Kiera Allen - [GitHub](https://github.com/KieraAllen)

### [Background and Instructions](https://github.com/turingschool-examples/monster_shop_final/blob/main/README.md)<br>

### Introduction

__Monster Shop Final__ was the project assigned to the 2008 Back End cohort during [Module 2](https://backend.turing.io/module2/). A [starter repo](https://github.com/turingschool-examples/monster_shop_final) was provided which included premade files or students could choose to build off their [group project repos](https://github.com/turingschool-examples/monster_shop_2005/network/members). Students were tasked with creating full CRUD functionality for a merchant employee to manipulate discounts on their merchant's items.

### Setup
For this final solo project, I chose to build off the provided repo, and followed these steps to set it up:

1. Forked [project](https://github.com/turingschool-examples/monster_shop_final)
2. Cloned fork
3. In terminal: `rails db:{drop,create,migrate,seed}`
4. Inspected schema, routes, tests
5. In terminal: `bundle exec rspec`
7. [Deploy](https://devcenter.heroku.com/articles/git) to Heroku
     1. `heroku create`
     2. `git remote -v`
     3. `git push heroku main`
8. Read over instructions
9. Develop rough user stories
10. Get to work!

### Demo
The app can be viewed on Heroku [here](https://gentle-temple-14305.herokuapp.com/)
- Notes:
    - append `/home` to the web address to view completed site
    - use `seeds` info to login as merchant employee to view discount functionality
