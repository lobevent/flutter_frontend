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

#### Closing

### Release branches

#### Generating

#### Closing

### Hotfix branches 

#### Generating

#### Closing
