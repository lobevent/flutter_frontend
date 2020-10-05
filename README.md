![test_and_build](https://github.com/lobevent/flutter_frontend/workflows/test_and_build/badge.svg?branch=develop)

# Flutter Frontend - repository for the frontend

Flutter App for iOS and Android for the lobevent project.

## Project structure explanation

The directory structure and layer structure is based on Reso Coder's DDD - Clean Architecture Course

![Layer structure](project_structure_utils/images/DDD-Flutter-Diagram.svg)

- [Detailed structure of the project can be found here](https://resocoder.com/2020/03/09/flutter-firebase-ddd-course-1-domain-driven-design-principles/)
- [All parts of the DDD course can be found here](https://resocoder.com/category/tutorials/flutter/firebase-ddd/)
- [A fully functional DDD github example project can be found here](https://github.com/ResoCoder/finished-flutter-firebase-ddd-course)

## Project Git Workflow

**The working branch should always be a `feature branch` or at least the `develop?` branch**

The workflow is taken from this [article](https://www.atlassian.com/de/git/tutorials/comparing-workflows/gitflow-workflow).
In general it follows the structure shown in the image below:

![Git structure](project_structure_utils/images/Git-Workflow-Diagram.svg)

### Branches and there usecases:

- `master` - only for releases (every commit needs a version tag in the format x.x.x)
- `develop` - main branch with complete development history
- `features` - feature branches can have self chosen names like 'new_search_event_feature' and are used for developing a new feature
- `release` - release branches are used to prepare a new release and usually are named the following way 'release_vx.x.x'
- `hotfix`- hotfix branches are used for bug fixes on a release and usually are named the following way 'hotfix_vx.x.x'

### Feature branches

#### Generating

1. Checkout developer branch: `git checkout develop`
2. Generate and checkout the new feature branch: `git checkout -b feature_branch_name`

#### Closing

1. Checkout developer branch: `git checkout develop`
2. Merge your finished feature branch: `git merge feature_branch_name`
3. Delete the branch: `git branch -D feature_branch_name`

### Release branches

#### Generating

1. Checkout developer branch: `git checkout develop`
2. Generate and checkout the new release branch: `git checkout -b release_v0.1.0`

#### Closing

1. Checkout master branch: `git checkout master`
2. Merge into master: `git merge release_v0.1.0`
3. Tag the version: `git tag -a v0.1.0 -m "Add some details about the verion 0.1.0"`
4. You have to push the changes **and** also have to explicitly push the tag the following way `git push origin v0.1.0`
5. (Optional) Merge into develop too if changes are not only for production: 
5.1 Checkout developer branch: `git checkout develop`
5.2 Merge into develop: `git merge release_v0.1.0`
6. Delete the branch: `git branch -D release_v0.1.0`

### Hotfix branches 

#### Generating

1. Checkout master branch: `git checkout master`
2. Generate and checkout the new hotfix branch: `git checkout -b hotfix_v0.1.1`

#### Closing

1. Checkout master branch: `git checkout master`
2. Merge into master: `git merge hotfix_v0.1.1`
3. Tag the version: `git tag -a v0.1.1 -m "Add some details about the hotfix verion 0.1.1"`
4. You have to push the changes **and** also have to explicitly push the tag the following way `git push origin v0.1.1`
5. Checkout developer branch: `git checkout develop`
6. Merge into develop: `git merge hotfix_v0.1.1`
7. Delete the branch: `git branch -D hotfix_v0.1.1`
