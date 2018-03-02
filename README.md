# Plenum
Clinical Knowledge Management cloud software including maps of referral routes with popup 
contact details, meeting minuter, issue tracker and KPI graphs.

Copyright (C) 2017-18 Mark Fuller

This software creates a container image which is part of a Docker stack. The Dockerfile pulls the 
php-apache-jessie image. Composer then installs the govcms8-project files and installs our 
extensions on top of that. Plenum config files are then installed into the GovCMS8 platform. 

The production stack contains 
  - a Traefik load-balancer which monitors the stack for deployment changes and handles 
    Let's Encrypt certificates. 
  - replicated webserver containers (this image) to allow rolling updates with rollback-on-fail
  - ClamAV antivirus scanning container for file uploads
  

Plenum builds on the GovCMS8 Drupal Distribution from the Australian Commonwealth Government
Department of Finance which in turn builds on Drupal. 
  - GovCMS8 is in **alpha state** as at 1/3/18. 
  - Plenum utilises Drupal contributed modules in **dev state** as at 1/3/18. 
  
This is currently unstable software although I use it every workday to manage my workload. All 
contributions are welcome. We will share our work with the upstream developers so that the 
community benefits. There is a stable, compliance-tested GovCMS version available from the 
Australian Commonwealth Government Department of Finance (based on Drupal 7).

This program is free software; you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation; either version 2 of the 
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without 
even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

The software installation folder should contain a copy of the GNU General Public License. If
not, it is available here: https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt

###Links
Plenum source code: https://gitlab.com/plenum/webserver-image