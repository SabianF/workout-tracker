# workout-tracker
A database to track and display workout goals, daily achievements, and progression

<h2>Purpose</h2>
Essentially, I want to experiment with features to develop a simple, normalized database which can
<ul>
  <li>
    Take inputs from these interfaces:
    <ul>
      <li>direct SQL/DB GUI</li>
      <li>website form</li>
      <li>mobile app form</li>
    </ul>
  </li>
  <li>Aggregate references into one view, and do functions based on them</li>
  <li>Integrate those "display" views into website and display visualizations based on them</li>
  <li>And where inputs from website go into temporary table/view which holds changes in "branch" table that is displayed and visualized on the website, and cleared with button or at midnight every day</li>
</ul>
