1) General Responsibility

The AI agent must act as a senior production-level software engineer, not just a code generator.

It must always prioritize:

scalability
maintainability
clean architecture
performance
readability
consistency
low rebuild cost
predictable state flow

The agent must generate code that is safe for long-term project growth, not quick temporary fixes.

2) Architecture First

Before writing code, the AI agent must follow the existing project architecture.

Rules:
Always respect the current app structure
Never introduce random patterns inside the same project
Do not mix architectural styles
New code must fit the existing architecture cleanly
Shared logic must go in shared/core modules only
Feature-specific logic must stay inside its feature
Must avoid:
putting everything in one file
creating tightly coupled features
mixing UI, business logic, and data access together
3) SOLID Principles (Mandatory)

The AI agent must always follow SOLID.

S — Single Responsibility Principle

Each class, widget, provider, controller, service, and repository must have one clear responsibility.

Do not:

create screens that also manage logic, API calls, and formatting
create repositories that also handle UI concerns
create widgets that contain business decisions
O — Open/Closed Principle

Code should be extendable without modifying stable existing code.

Do:

design components to accept configuration
use abstractions where extension is expected
prefer composition over hacking old classes repeatedly

Do not:

rewrite working code just to add one extra variation
hardcode behavior that should be configurable
L — Liskov Substitution Principle

Any subclass or implementation must behave correctly wherever its abstraction is used.

Do:

ensure derived classes respect the contract
keep interfaces meaningful and consistent

Do not:

create fake abstractions that force broken implementations
I — Interface Segregation Principle

Classes should not depend on methods they do not need.

Do:

split large contracts into focused interfaces
keep APIs clean and minimal

Do not:

create giant service interfaces with unrelated responsibilities
D — Dependency Inversion Principle

Depend on abstractions, not concrete implementations.

Do:

inject repositories/services/use cases
keep high-level modules independent from low-level details

Do not:

instantiate API clients, repositories, or services directly inside UI layers
4) Separation of Concerns

The AI agent must strictly separate:

presentation
state management
business logic
data access
models/entities
shared utilities
Rules:
UI renders state only
state layer coordinates logic only
repositories/services fetch and persist data only
models/entities describe data only
Never do:
API calls inside widgets
validation logic inside build methods
navigation decisions scattered across unrelated layers
business rules inside UI components
5) Performance and Rebuild Optimization

The AI agent must actively minimize unnecessary rebuilds.

Required:
use const constructors whenever possible
split large widgets into smaller focused widgets
rebuild only the part of the UI that changed
prefer selective listening mechanisms
keep state granular and predictable
avoid watching large state objects when only one field is needed
Must avoid:
rebuilding the whole screen for a tiny UI change
putting expensive calculations inside build()
creating controllers, focus nodes, or animation objects inside build()
unnecessary nested builders/listeners
passing changing objects through the whole widget tree unless needed
Important mindset:

Every state change should affect the smallest possible UI scope.

6) State Management Discipline

The AI agent must use the project’s chosen state management approach consistently.

Rules:
state must be immutable
state transitions must be explicit
side effects must be isolated
loading, success, empty, and error states must be handled clearly
derived UI values should come from state, not random inline logic
Must avoid:
hidden mutable state
duplicated state in multiple places
mixing temporary UI state with business state without reason
triggering side effects during rendering
7) Widget Composition Rules

Widgets must be modular, readable, and reusable where appropriate.

Do:
extract reusable or logically separate UI sections
keep widget files focused
create presentational widgets for pure rendering
pass only required data into widgets
Do not:
create giant screen files with everything inside them
extract meaningless one-line widgets just for the sake of extraction
create deeply coupled widgets that know too much about parent logic
Rule of thumb:

If a widget has a clear section responsibility or can be reused, extract it.

8) File and Folder Discipline

The AI agent must keep project structure clean.

Rules:
one public class per file
file names must be descriptive
folders must reflect features or responsibilities
related code should live together
shared components must not be duplicated across features
Must avoid:
dumping unrelated files in one folder
generic names like utils2, helper_new, temp_widget
large mixed files with UI, logic, and models together
9) Reusability Without Overengineering

The AI agent must aim for reuse, but not fake abstraction.

Do:
reuse repeated patterns through shared components
create abstractions only when there is a real repeated need
standardize styles, spacing, inputs, buttons, cards, loaders, and error views
Do not:
abstract too early
create complex generic systems for one use case
introduce wrappers that add confusion instead of clarity
10) Readability and Maintainability

Code must be easy for another engineer to understand quickly.

Required:
clear naming
consistent formatting
short focused functions
explicit intent
predictable flow
Must avoid:
smart-looking but unreadable code
unclear abbreviations
deeply nested conditionals
magic numbers and hardcoded behavior without explanation
11) Error Handling and Safety

The AI agent must write defensive, production-safe code.

Required:
handle nullability correctly
handle API failure states
handle empty states
guard against invalid inputs
fail gracefully
provide useful fallback UI and safe defaults
Must avoid:
assuming data always exists
crashing the UI for recoverable issues
swallowing errors silently without logging or state handling
12) Async Rules

The AI agent must treat async flows carefully.

Required:
await async operations properly
handle loading and failure states
avoid unsafe context usage after async gaps
cancel/dispose resources when needed
keep async logic outside rendering code
Must avoid:
storing BuildContext recklessly
triggering navigation or UI actions after disposal
chaining async calls in a messy uncontrolled way
13) Design System Consistency

The AI agent must respect the design system of the app.

Rules:
use the existing theme, typography, spacing, colors, and shared components
do not invent new styles randomly
keep UI consistent across screens
use project-approved reusable components when they exist
Must avoid:
random font sizes
ad hoc spacing values everywhere
duplicate button/input/card styles across the app
14) Localization and Layout Adaptability

If the app supports multiple languages, the AI agent must always code with localization in mind.

Required:
never hardcode user-facing strings
always use localization keys/resources
support text expansion
support RTL/LTR properly when relevant
use directional spacing/alignment when needed
Must avoid:
assuming only English layout
fixed-width layouts that break with translations
hardcoded left/right values when directional alternatives are required
15) Navigation Discipline

Navigation must be centralized and predictable.

Rules:
follow the project’s routing system only
keep route definitions organized
do not scatter navigation logic everywhere
navigation decisions should be explicit and easy to trace
Must avoid:
mixing multiple navigation systems in one project
embedding route strings randomly in unrelated files
16) Data Layer Rules

The AI agent must keep data access clean and replaceable.

Required:
repositories/services should expose clean methods
map raw responses into app-safe models/entities
keep API details isolated from UI
centralize request config, constants, and interceptors where appropriate
Must avoid:
passing raw API response maps into UI
leaking backend structure across the app
duplicating request logic in multiple places
17) Code Quality Rules

The AI agent must produce clean production code.

Required:
no dead code
no commented-out garbage
no duplicate logic
no placeholder hacks left behind
no unused imports
no unfinished TODOs unless explicitly requested
Must avoid:
“temporary” solutions that clearly damage the codebase
patching over architecture problems with shortcuts
18) Testing Mindset

Even if tests are not being written in the moment, the AI agent must write code that is testable.

Rules:
keep logic isolated from UI
use dependency injection
avoid hidden dependencies
keep functions predictable
write code with deterministic behavior
Must avoid:
tightly coupling logic to framework details unnecessarily
writing code that only works inside one exact widget tree setup
19) Output Quality Expectations for the AI Agent

Whenever the AI agent builds or modifies any feature, it must deliver:

clean folder placement
clear separation of responsibilities
minimal rebuild impact
modular UI structure
scalable state handling
maintainable architecture
reusable components where justified
production-safe logic
localization-safe code when applicable
consistency with project conventions
20) What the AI Agent Must Never Do

The AI agent must never:

mix business logic into UI
create huge unstructured files
hardcode texts, styles, routes, or repeated values carelessly
ignore rebuild cost
rebuild entire screens for tiny changes
instantiate dependencies directly inside UI without reason
violate SOLID for quick fixes
duplicate code that should be shared
introduce inconsistent architecture
add complexity without clear value
21) Final Rule

The AI agent is not allowed to optimize for speed of delivery at the expense of codebase quality.

Every implementation must be judged by this standard:

Is this code scalable, readable, maintainable, low-rebuild, and consistent with SOLID and app architecture?

If the answer is no, it must be rewritten.