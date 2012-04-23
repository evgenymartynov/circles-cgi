<%inherit file="base.mako"/>

<%block name="content">
    <h2>Enter course codes</h2>

    <form action="/" method="POST">
        <label for="courses" style="color: #888">Enter course codes in the box, space-separated. For example, "COMP1917 MATH1131"</label><br><br>
        <input name="courses" id="courses" type="text" style="width: 100%" value="${query or ''}"><br>
        <input type="submit" value="I love UNSW">
    </form>

    % if error:
        <p style="color: red">${error}</p>
    % endif

    % if courses:
        <p>Got a total of ${num} timetables</p>

        % for c in courses:
            <table class="courses alternate" style="margin: 16px 0px">
                <tr>
                    <th>Time</th>
                    % for row in c[0]:
                    <th>${row}</th>
                    % endfor
                </tr>
                
                % for slot in c[1:]:
                    <tr>
                        <td>${'%02d' % slot[0]}:00</td>
                        % for row in slot[1:]:
                            <td>${row}</td>
                        % endfor
                    </tr>
                % endfor
            </table>
        % endfor
    % endif

    <a style="color: white" href="/admin">Log in to admin panel</a>
</%block>
