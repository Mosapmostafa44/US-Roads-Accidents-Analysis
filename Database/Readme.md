## **Database Design**

The database is structured to store U.S. traffic accident records in a clean, normalized format.

**Core Tables:**

* **Accident** — Stores accident details (date, day of week, type, visibility, speed limit, number of casualties, emergency response time) and links to related data through foreign keys.
* **Location** — Records the accident location, linked to a state, with distances to the nearest hospital and police station.
* **State** — Stores state names.
* **Road** — Linked to a location, road type, and junction type; contains physical attributes like road width and surface friction coefficient.
* **Weather\_Conditions**, **Road\_Conditions**, **Light\_Conditions** — Store descriptions of environmental factors.
* **Accident\_Types**, **Vehicle\_Types**, **Driver\_Age\_Groups** — Contain standardized categorical values.

**Linking Table:**

* **Accident\_Vehicle** — Connects accidents with vehicles and drivers, storing vehicle speed and the number of vehicles involved.

**Relationships:**

* Each accident is linked to exactly one location, road, weather, road condition, light condition, and accident type.
* Locations belong to one state.
* Roads are linked to one location, one road type, and one junction type.
* Many-to-many relationships between accidents, vehicles, and drivers are resolved through the `Accident_Vehicle` table.