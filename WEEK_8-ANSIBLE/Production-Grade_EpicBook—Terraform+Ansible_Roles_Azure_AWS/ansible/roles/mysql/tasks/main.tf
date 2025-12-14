---
- name: Ensure mysql-client is present
  apt:
    name: mysql-client
    state: present
    update_cache: yes

- name: Create app DB marker dir
  file:
    path: /opt/epicbook-db
    state: directory
    mode: '0755'

- name: Copy schema and seed SQL to remote (if not present)
  copy:
    src: "{{ item }}"
    dest: "/opt/epicbook-db/{{ item | basename }}"
    mode: 0644
  loop:
    - db/BuyTheBook_Schema.sql
    - db/author_seed.sql
    - db/books_seed.sql
  # This expects your playbook runner to be in repo root where db/ exists. Alternatively, use get_url or template.

- name: Import schema if not already imported
  shell: >
    mysql -h {{ db_host }} -u {{ db_username }} -p'{{ db_password }}' -e "use {{ db_name }};"
  register: check_db
  failed_when: false
  changed_when: false

- name: Create database if missing
  shell: >
    mysql -h {{ db_host }} -u {{ db_username }} -p'{{ db_password }}' -e "CREATE DATABASE IF NOT EXISTS {{ db_name }};"
  when: check_db.rc != 0
  register: create_db
  changed_when: create_db.rc == 0

- name: Import schema file
  shell: >
    mysql -h {{ db_host }} -u {{ db_username }} -p'{{ db_password }}' {{ db_name }} < /opt/epicbook-db/BuyTheBook_Schema.sql
  args:
    creates: /opt/epicbook-db/.schema_imported
  register: import_schema
  failed_when: import_schema.rc != 0

- name: Touch schema import marker
  file:
    path: /opt/epicbook-db/.schema_imported
    state: touch
  when: import_schema is changed

- name: Import author seed
  shell: >
    mysql -h {{ db_host }} -u {{ db_username }} -p'{{ db_password }}' {{ db_name }} < /opt/epicbook-db/author_seed.sql
  args:
    creates: /opt/epicbook-db/.author_seed
  register: import_auth
  failed_when: import_auth.rc != 0

- name: Touch author seed marker
  file:
    path: /opt/epicbook-db/.author_seed
    state: touch
  when: import_auth is changed

- name: Import books seed
  shell: >
    mysql -h {{ db_host }} -u {{ db_username }} -p'{{ db_password }}' {{ db_name }} < /opt/epicbook-db/books_seed.sql
  args:
    creates: /opt/epicbook-db/.books_seed
  register: import_books
  failed_when: import_books.rc != 0

- name: Touch books seed marker
  file:
    path: /opt/epicbook-db/.books_seed
    state: touch
  when: import_books is changed
