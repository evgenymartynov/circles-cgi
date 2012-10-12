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
            <option value="early" ${'selected="selected"' if sort_order=='early' else ''}>Penalise early (before 12) starts</option>
            <option value="late" ${'selected="selected"' if sort_order=='late' else ''}>Penalise late (after 16) finishes</option>
            <option value="lazy" ${'selected="selected"' if sort_order=='lazy' else ''}>Optimise for the lazy student (late start, early finish)</option>
        </select>
        <br>
        <label for="clash_hours" style="color: #888">Also allow this many clash hours (max 3):</label>
        <input name="clash_hours" id="clash_hours" type="text" value="${clash_hours or ''}"><br>
        <br>
        <input type="submit" value="Show me the circles">
    </form>

    % if error:
        <p style="color: red">${error}</p>
    % endif

    % if type(courses) is list and len(courses) == 0:
        <p style="color: blue">Could not find any non-clashing timetables :(</p>
    % endif

    % if courses:
        <p>Got a total of ${num} timetables (showing ${len(courses)})</p>

        <p style="color: grey">Known bug: if your course has some class once or twice throughout a semester, Circles will think that it runs throughout the entire semester. Use Rectangles if that is the case.</p>

        % for c in courses:
            <%
                colours = {}
                palette = ['purple', 'red', 'blue', 'yellow', 'green', 'orange']
                pindex = 0
                import zlib, base64, json
                cdata = base64.urlsafe_b64encode(zlib.compress(json.dumps(c)))
            %>

            <p class="timetable-link"><a href="/link?t=${cdata}">Link to the timetable below</a></p>
            <table class="courses alternate">
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
                                    SEP = ' & '
                                    colour = ''
                                    conseq = 1
                                    subjects = row.split(SEP)
                                    if len(row) > 1:
                                        rows = []
                                        if SEP in row:
                                            colour = 'clash red'
                                        else:
                                            subject = row.split()[0]
                                            if subject not in colours:
                                                colours[subject] = palette[pindex]
                                                pindex = (pindex + 1) % len(palette)
                                            colour = colours[subject]

                                        conseq = 1
                                        while 1+si+conseq < len(c) and row == c[1+si+conseq][1+ri]:
                                            c[1+si+conseq][1+ri] = '*'
                                            conseq += 1
                                        titles = map(lambda t: '<b>%s</b> %s' % tuple(t.split(' ', 1)), row.split(SEP))
                                        rows.append((conseq, '<br>'.join(titles), colour))
                                %>
                                % if len(row) > 1:
                                    % for _row in rows:
                                    <%
                                        conseq, row, colour = _row
                                        radius  = 40    # Radius of the circles
                                        padding = 25    # = csswidth/2 - radius
                                    %>
                                    <span style="position: relative">
                                        <div style="position: absolute; left: ${-(conseq-1)*radius+padding}px; width: ${conseq*radius*2}px; height: ${conseq*radius*2}px" class="cell ${colour}"></div>
                                        <div style="position: absolute; left: ${padding}px; top: ${conseq*radius - 25}px; vertical-align: middle; text-align: center; width: ${radius*2}px" class="cell-text ${colour}">${row if len(row) > 1 else '' | n}</div>
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
