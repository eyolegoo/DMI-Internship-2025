---
- name: Install nginx
  apt:
    name: nginx
    state: present
    update_cache: yes

- name: Ensure /var/www exists
  file:
    path: /var/www
    state: directory

- name: Place epicbook nginx config
  template:
    src: epicbook.conf.j2
    dest: /etc/nginx/sites-available/epicbook
  notify: Reload nginx

- name: Enable site by symlinking
  file:
    src: /etc/nginx/sites-available/epicbook
    dest: /etc/nginx/sites-enabled/epicbook
    state: link
  notify: Reload nginx

- name: Remove default site if present
  file:
    path: /etc/nginx/sites-enabled/default
    state: absent
  notify: Reload nginx

- name: Test nginx config
  command: nginx -t
  register: nginx_test
  failed_when: nginx_test.rc != 0

- name: Ensure nginx is started and enabled
  systemd:
    name: nginx
    state: started
    enabled: yes
