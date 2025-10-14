// function showRoleDetail(el) {
//     var roleId = el.getAttribute('data-role-id');
//     var roleName = el.getAttribute('data-role-name');
//     // Lấy permission từ script tag
//     var permData = document.getElementById('perm-data-' + roleId);
//     var permissions = [];
//     if (permData) {
//         permissions = JSON.parse(permData.textContent);
//     }
//     // Set modal content
//     document.getElementById('modalRoleName').innerText = roleName;
//     var ul = document.getElementById('modalPermissionList');
//     ul.innerHTML = '';
//     if (permissions.length === 0) {
//         ul.innerHTML = '<li><em>No permission</em></li>';
//     } else {
//         permissions.forEach(function(p) {
//             var li = document.createElement('li');
//             li.innerText = p;
//             ul.appendChild(li);
//         });
//     }
//     // Show modal (Bootstrap 5)
//     var modal = new bootstrap.Modal(document.getElementById('roleDetailModal'));
//     modal.show();
// }