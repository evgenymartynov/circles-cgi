<%inherit file="base.mako"/>

<%block name="content">
    <h2>Enter course codes</h2>

    <form action="/" method="POST">
        <label for="courses" style="color: #888">Enter course codes in the box, space-separated. For example, "COMP1917 MATH1131"</label><br><br>
        <input name="courses" id="courses" type="text" style="width: 100%" value="${query or ''}"><br>
        <label for="sort_order" style="color: #888">Sorting order:</label>
        <select name="sort_order" id="sort_order">
            <option value="free" ${'selected="selected"' if sort_order=='free' else ''}>Put timetables with most free weekdays first</option>
            <option value="unfree" ${'selected="selected"' if sort_order=='unfree' else ''}>Least free weekdays first</option>
            <option value="hours" ${'selected="selected"' if sort_order=='hours' else ''}>Least hours at uni first</option>
        </select>
        <br>
        <label for="clash_hours" style="color: #888">Also allow this many clash hours (max 3):</label>
        <input name="clash_hours" id="clash_hours" type="text" value="${clash_hours or ''}"><br>
        <br>
        <input type="submit" value="I love UNSW">
    </form>

    % if error:
        <p style="color: red">${error}</p>
    % endif

    % if type(courses) is list and len(courses) == 0:
        <p style="color: blue">Could not find any non-clashing timetables :(</p>
    % endif

    <p style="color: grey">The server breaks and goes down a lot. Don't rely on Circles being up all the time. This was a one-day project, and I am not going to maintain it in the future.</p>

    % if courses:
        <p>Got a total of ${num} timetables</p>

        % for c in courses:
            <%
                colours = {}
                palette = ['purple', 'red', 'blue', 'yellow', 'green', 'orange']
                pindex = 0
            %>
            <table class="courses alternate" style="margin: 16px 0px">
                <tr>
                    <th>Time</th>
                    % for row in c[0]:
                    <th>${row}</th>
                    % endfor
                </tr>
                
                % for si, slot in enumerate(c[1:]):
                    <tr>
                        <td>${'%02d' % slot[0]}:00</td>
                        % for ri, row in enumerate(slot[1:]):
                            <td>
                                <%
                                    colour = ''
                                    conseq = 1
                                    subjects = row.split(' | ')
                                    if len(row) > 1:
                                        rows = []
                                        for subj in subjects:
                                            if subj not in colours:
                                                colours[subj] = palette[pindex]
                                                pindex = (pindex + 1) % len(palette)
                                            colour = colours[subj]
                                            conseq = 1
                                            while 1+si+conseq < len(c) and subj in c[1+si+conseq][1+ri]:
                                                temp = c[1+si+conseq][1+ri].split(' | ')
                                                if subj in temp:
                                                    temp.remove(subj)
                                                c[1+si+conseq][1+ri] = ' | '.join(temp) or '*'
                                                conseq += 1
                                            rows.append((conseq, subj, colour))
                                %>
                                % if len(row) > 1:
                                    % for _row in rows:
                                    <%
                                        conseq, row, colour = _row
                                    %>
                                    <span style="position: relative">
                                        <div style="position: absolute; left: ${-(conseq-1)*50+15}px; width: ${conseq*100}px; height: ${conseq*100}px" class="cell ${colour}"></div>
                                        <div style="position: absolute; left: 15px; top: ${conseq*50 - 25}px; vertical-align: middle; text-align: center; width: 100px" class="cell-text ${colour}">${row if len(row) > 1 else ''}</div>
                                    </span>
                                    % endfor
                                % endif
                            </td>
                        % endfor
                    </tr>
                % endfor
            </table>
        % endfor
    % endif

    <a style="color: white" href="/admin">Log in to admin panel</a>
</%block>
