#  Prompt
I am making a productivity app for my final project. I am still an intermediate coder so I don’t want it to be super complicated. Mainly, I want: 
- a place to fill out tasks 
- ability to group these tasks into categories (school, personal) and add custom one 
- sort tasks by priority (high, medium, low) 
- ability to X out tasks as you complete them
What I want you to do is create a prompt that I can feed to the LLM in XCode that will give me a good structure for this app.

Create a simple but well-structured productivity task manager app using SwiftUI and MVVM architecture. This app is for an intermediate iOS developer, so keep the code readable, modular, and not overly complex.

Core Features:

1. Task Creation

* Users can create tasks with:

  * A task title (String)
  * A category (default categories: School and Personal, plus ability to add custom categories)
  * A priority level (High, Medium, Low)
  * A completion status (checkbox or toggle)

2. Task Categories

* Users can assign tasks to categories
* Include default categories:

  * School
  * Personal
* Allow users to create custom categories
* Tasks should be grouped visually by category in the main list view

3. Priority Sorting

* Each task has a priority:

  * High
  * Medium
  * Low
* Tasks should be sortable by priority
* High priority tasks should appear first when sorted

4. Task Completion

* Users can mark tasks as completed
* Completed tasks should visually appear crossed out or faded
* Users should be able to delete tasks

Technical Requirements:

* Use SwiftUI
* Use MVVM architecture
* Create the following components:

  * Task model (Identifiable, Codable)
  * Category model
  * Priority enum
  * TaskViewModel to manage tasks
  * Main TaskListView
  * AddTaskView (modal sheet)
  * Category management logic
* Use @StateObject and @Published where appropriate
* Store tasks locally using simple persistence (UserDefaults or Codable file storage — not CoreData)

UI Requirements:

* Use NavigationStack
* Include:

  * A main task list screen
  * A button to add new tasks
  * A picker for category selection
  * A picker or segmented control for priority
  * A toggle or checkmark button to mark tasks completed
* Keep UI clean and minimal

Important Constraints:

* Do NOT use CoreData
* Do NOT use external libraries
* Keep logic simple and beginner-friendly
* Add clear comments explaining each major section
* Make the project compile without errors
* Build the project step-by-step, starting with models, then ViewModel, then Views

Output Instructions:

Generate the code in logical sections in this order:

1. Models (Task, Category, Priority)
2. ViewModel
3. Main List View
4. Add Task View
5. Persistence Logic

Explain briefly how each file should be created and connected in Xcode.

